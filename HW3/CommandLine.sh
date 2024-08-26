#!/usr/bin/env bash

#### DISCLAIMER ####
# Surfing on the internet while doing this exercise I've found a lot of solutions which mention "awk". The script would have been cleaner, surely, but I don't know if it's cheating so I opted to use pure bash. Hope this helps understanding why there are some loops, which inevitably affect the performances.


# 1 - Merge master courses into a single tsv file

# Insert the header at the first line
echo -e "Course Name\tUniversity Name\tFaculty Name\tDescription\tFees\tModality\tDuration\tCity\tCountry\tLink\tadministration" > merged_courses.tsv 
# Copy the content of each other file
cat tsv_documents/*.tsv >> merged_courses.tsv 
# From now on, we will use "| tail -n +2 |" to exclude the header when calling "merged_courses.tsv"



# 2 - Count country and city which offer the most number of MSCs

echo "1) Country and city which offer the most number of MSCs are:"
# Count how many times each country/city occurs in the dataset, then sort them and take the last element (maximum)
cut -f 9 merged_courses.tsv | tail -n +2 | sort | uniq -c | sort -n | tail -1 # Country
cut -f 8 merged_courses.tsv | tail -n +2 | sort | uniq -c | sort -n | tail -1 # City
echo ""



# 3 - Count colleges offering part time education

# Preprocess "Duration" column
echo -e "Course Name\tUniversity Name\tFaculty Name\tDescription\tFees\tModality\tDuration\tCity\tCountry\tLink\tadministration" > new.tsv 
while IFS=$'\t' read -a array; do
    # Replace value with "1" when it is part time, else "0"
    if [[ ${array[6]} =~ "part" ]]; then
       array[6]=1
    else
       array[6]=0
    fi
    
    # Print the new rows in a new file (a bit tricky in pure bash)
    echo -n "${array[0]}"
    for i in {1..9}; do
       echo -n -e "\t${array[$i]}";
    done
    echo -e "\t${array[10]}";
done < merged_courses.tsv | tail -n +2 >> new.tsv

# Use an associative array to count number of part time MSCs for each university
declare -A tempsum
npt=0
cat new.tsv | tail -n +2 | ( while IFS=$'\t' read -a array; do
    # Count
    ((tempsum["${array[1]}"]+=${array[6]}));
done 
# Count how many universities have at least one part time MSC, leveraging the counter computed previously
for j in "${!tempsum[@]}"; do
    if [[ ${tempsum[$j]} != 0 ]]; then
       ((npt+=1))
    fi
    #echo "$j,${tempsum[$j]}"; if you want to visualize the count of part time MSCs for every university
done 
echo "2) As of now, $npt universities provide at least one part-time MSC" )
echo ""



# 4 - Calculate the percentage of courses with the word "Engineer" in their name

# Count how many rows have got the word "Engineer" in the first column
neng=$(cut -f 1 merged_courses.tsv | tail -n +2 | grep -c "Engineer") # case sensitive
# Count the total number of rows (courses)
nrows=$(cat merged_courses.tsv | tail -n +2 | wc -l)
# Compute the percentage and print it
totalperc=$(echo "scale=4;($neng/$nrows)*100" | bc)
echo "3) Courses in engineering represent the $totalperc% of the total"
