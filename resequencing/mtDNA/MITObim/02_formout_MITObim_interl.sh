




for filename in *.out; do
  FPATH=$(tac $filename | awk 'NR==10' | cut -c 48-)
  SAMPLE=$(echo $FPATH | cut -c 111- | rev | cut -c 24- | rev )
  sed -i "1s/.*/>${SAMPLE}/" $FPATH
done
