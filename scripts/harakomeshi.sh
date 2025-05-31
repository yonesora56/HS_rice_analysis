#!/bin/bash
#Created with reference to ikra.sh
set -xe

PROGNAME="$( basename $0 )" 
VERSION="v1.0.0"
EXECUTION_DATE=$(date +%Y/%m/%d" "%H:%M:%S)

# Arguments
CSV_FILE=$1
OUTPUT_FILE=$2
CONFIG_YAML=$3

#Usage
function usage() {
    cat << EOS >&2 
${PROGNAME} ${VERSION} 
    Usage: $0 <SRR csv file> <output.tsv file name> <config.yml file>
    args:
        csv file (like ikra.sh format)
        output.tsv file name
        config.yml file (for execution)
EOS
    exit 1
}

#Arguments Check
if [ -z "$CSV_FILE" ] || [ -z "$CONFIG_YAML" ]; then
    usage
fi

########## Set Variables ##########
# 1.species
SPECIES_NAME=$(yq e '.species.species_name' "$CONFIG_YAML")
BINOMIAL_NAME=$(yq e '.species.binomial_name' "$CONFIG_YAML")
ENSEMBL_RELEASE=$(yq e '.species.ensembl.release' "$CONFIG_YAML")
REF_TRANSCRIPT=$(yq e '.species.ensembl.ref_transcript' "$CONFIG_YAML")
REF_TRANSCRIPT_URL="https://ftp.ensemblgenomes.ebi.ac.uk/pub/plants/release-"${ENSEMBL_RELEASE}"/fasta/"${BINOMIAL_NAME}"/cdna/"${REF_TRANSCRIPT}""
# 2. threads
THREADS=$(yq e '.settings.threads' "$CONFIG_YAML")
# 3. docker run
DRUN="docker run -u $(id -u):$(id -g) --rm -v $(pwd):/home -e HOME=/home --workdir /home"
# 4. salmon
SALMON_INDEX="salmon_index_${SPECIES_NAME}_release${ENSEMBL_RELEASE}"
SALMON_IMAGE=$(yq e '.settings.salmon.docker_image' "$CONFIG_YAML")
# 5. tximport
TX2GENEID=$(yq e '.settings.tximport.convert_file' "$CONFIG_YAML")



########## fasterq-dump ##########

tail -n +2 $CSV_FILE | tr -d '\r' | while IFS= read -r i || [[ -n "$i" ]]; do
    name=$(echo $i | cut -d ',' -f 1)
    SRR=$(echo $i | cut -d ',' -f 2)
    LAYOUT=$(echo $i | cut -d ',' -f 3)
    dirname_fq="./"

    # Separate process for SE and PE
    if [ "$LAYOUT" = "SE" ]; then
    # if SE...
        if [[ ! -f "${SRR}_trimmed.fq.gz" ]]; then
            if [[ ! -f "${SRR}.fastq.gz" ]]; then
                fasterq-dump ${SRR} --threads $THREADS -p # fasterq-dump from SRR file 
                pigz -p $THREADS "${SRR}.fastq"
            fi
        fi

    elif [ "$LAYOUT" = "PE" ]; then
     # if PE...
        if [[ ! -f "${SRR}_1_trimmed.fq.gz" ]]; then
            if [[ ! -f "${SRR}_1.fastq.gz" ]]; then
                fasterq-dump $SRR --threads $THREADS -p
                # fastp command is successful, remove the original fastq files
                pigz -p $THREADS "${SRR}_1.fastq"
                pigz -p $THREADS "${SRR}_2.fastq"
            fi
        fi
    else
    echo "Invalid layout: $LAYOUT"
    exit 1
    fi 
done

########## fastp ##########
tail -n +2 $CSV_FILE | tr -d '\r' | while IFS= read -r i || [[ -n "$i" ]]; do
    name=$(echo $i | cut -d ',' -f 1)
    SRR=$(echo $i | cut -d ',' -f 2)
    LAYOUT=$(echo $i | cut -d ',' -f 3)
    dirname_fq="./"

# Separate process for SE and PE
    if [ "$LAYOUT" = "SE" ]; then
    # if SE...
        if [[ ! -f "salmon_output_${SRR}" ]]; then
            if [[ ! -f "${SRR}_trimmed.fq.gz" ]]; then
                if [[ -f "${SRR}.fastq.gz" ]]; then
                    fastp \
                    -i "${SRR}.fastq.gz" \
                    -o "${SRR}_trimmed.fq.gz" \
                    -h "${SRR}.html" \
                    -j "${SRR}.json" \
                    -w $THREADS
                    # fastp command is successful, remove the original fastq file
                    rm "${SRR}.fastq.gz"
                else
                    echo "Error: ${SRR}.fastq.gz does not exist. Run fasterq-dump first."
                    exit 1
                fi
            fi
        fi

    elif [ "$LAYOUT" = "PE" ]; then
     # if PE...
        if [[ ! -f "salmon_output_${SRR}" ]]; then
            if [[ ! -f "${SRR}_1_trimmed.fq.gz" ]]; then
                if [[ -f "${SRR}_1.fastq.gz" ]]; then
                    fastp \
                    -i "${SRR}_1.fastq.gz" \
                    -I "${SRR}_2.fastq.gz" \
                    -o "${SRR}_1_trimmed.fq.gz" \
                    -O "${SRR}_2_trimmed.fq.gz" \
                    -h "${SRR}.html" \
                    -j "${SRR}.json" \
                    -w $THREADS \
                    --detect_adapter_for_pe
                    # fastp command is successful, remove the original fastq files
                    rm "${SRR}_1.fastq.gz"
                    rm "${SRR}_2.fastq.gz"
                else
                    echo "Error: ${SRR}_1.fastq.gz does not exist. Run fasterq-dump first."
                    exit 1
                fi
            fi
        fi
    else
    echo "Invalid layout: $LAYOUT"
    echo "See fastp --help"
    exit 1
    fi 
done

########## salmon ##########
# instance salmon index
if [[ ! -d $SALMON_INDEX ]]; then
    if [[ ! -f $REF_TRANSCRIPT ]]; then
        curl -O "$REF_TRANSCRIPT_URL"
    fi

    $DRUN $SALMON_IMAGE salmon index \
    --threads $THREADS \
    --transcripts $REF_TRANSCRIPT \
    --index $SALMON_INDEX \
    -k 31 # for 64bit machine
fi

# quantification
tail -n +2 $CSV_FILE | tr -d '\r' | while IFS= read -r i || [[ -n "$i" ]]; do
    name=$(echo $i | cut -d ',' -f 1)
    SRR=$(echo $i | cut -d ',' -f 2)
    LAYOUT=$(echo $i | cut -d ',' -f 3)
    dirname_fq=""

    # SE 
    if [ $LAYOUT = "SE" ]; then
        if [[ ! -f "salmon_output_${SRR}/quant.sf" ]]; then
            mkdir salmon_output_${SRR}
            # libtype auto detection mode (ikra) 
            $DRUN $SALMON_IMAGE salmon quant \
            --index $SALMON_INDEX \
            --libType A \
            --unmatedReads ./${SRR}_trimmed.fq.gz \
            --output salmon_output_${SRR} \
            --seqBias \
            --gcBias \
            --posBias \
            --threads $THREADS \
            --validateMappings \
            --numBootstraps 100 \
            --writeUnmappedNames
        fi
    # PE
    elif [ $LAYOUT = "PE" ]; then
        if [[ ! -f "salmon_output_${SRR}/quant.sf" ]]; then 
            mkdir salmon_output_${SRR}
            # libtype auto detection mode (ikra)
            $DRUN $SALMON_IMAGE salmon quant \
            --index $SALMON_INDEX \
            --libType A \
            --mates1 ./${SRR}_1_trimmed.fq.gz \
            --mates2 ./${SRR}_2_trimmed.fq.gz \
            --output salmon_output_${SRR} \
            --seqBias \
            --gcBias \
            --posBias \
            --threads $THREADS \
            --validateMappings \
            --numBootstraps 100 \
            --writeUnmappedNames
        fi
    else
        echo "Invalid layout: $LAYOUT"
    fi

    if [[ -f "salmon_output_${SRR}/logs/salmon_quant.log" ]]; then
    mv "salmon_output_${SRR}/logs/salmon_quant.log" "salmon_output_${SRR}/logs/${SRR}_salmon_quant.log"
    fi

done

########## tximport ##########
if [[ ! -f "$OUTPUT_FILE" ]]; then
    Rscript tximport_R.R $TX2GENEID $CSV_FILE $OUTPUT_FILE
fi

# using $() for command substitution not ${} 
cat << EOS
RUN : success!
End time : $(date +%Y/%m/%d" "%H:%M:%S)
EOS

