python calculate_sequence_stats.py input.fasta output.csv




import csv
from Bio import SeqIO

def calculate_sequence_stats(fasta_file):
    """
    Calculates the mean, minimum, and maximum sequence lengths, count of sequences,
    and N50 from a FASTA file. Returns a dictionary with the results.
    """
    # Initialize an empty list to hold the lengths of all the sequences in the FASTA file
    lengths = []
    # Initialize a counter for the number of sequences in the FASTA file
    count = 0
    # Parse the FASTA file using Biopython's SeqIO module
    for record in SeqIO.parse(fasta_file, "fasta"):
        # Get the length of the sequence and append it to the list of lengths
        seq_length = len(record.seq)
        lengths.append(seq_length)
        # Increment the sequence count
        count += 1

    # Calculate the total length of all the sequences
    total_length = sum(lengths)
    # Calculate the mean sequence length
    mean_length = total_length / count
    # Calculate the minimum sequence length
    min_length = min(lengths)
    # Calculate the maximum sequence length
    max_length = max(lengths)

    # Sort the list of sequence lengths in descending order
    sorted_lengths = sorted(lengths, reverse=True)
    # Initialize variables for calculating the N50 value
    n50 = None
    n50_threshold = total_length / 2
    cumsum = 0
    # Iterate over the sorted list of sequence lengths, adding each length to a running total
    # until the total length is greater than or equal to half the total length of all the sequences
    for length in sorted_lengths:
        cumsum += length
        if cumsum >= n50_threshold:
            # When the total length reaches the N50 threshold, set the N50 value and break out of the loop
            n50 = length
            break

    # Create a dictionary with the calculated sequence stats
    result = {
        "mean_length": mean_length,
        "min_length": min_length,
        "max_length": max_length,
        "count": count,
        "n50": n50
    }
    return result

# Replace 'input.fasta' with the path to your input FASTA file
input_file = "input.fasta"

# Replace 'output.csv' with the path to the output file you want to create
output_file = "output.csv"

# Calculate the sequence stats and write them to the output file
result = calculate_sequence_stats(input_file)
# Open the output file in write mode, and use csv.DictWriter to write the results as a CSV file
with open(output_file, "w", newline='') as f:
    writer = csv.DictWriter(f, fieldnames=result.keys())
    # Write the headers as the first row of the CSV file
    writer.writeheader()
    # Write the sequence stats as the second row of the CSV file
    writer.writerow(result)
