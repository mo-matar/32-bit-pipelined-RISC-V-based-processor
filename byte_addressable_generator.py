# Open the file.dat for reading
with open("test.txt", "r") as file:
    # Loop through each line in the file
    for line in file:
        # Remove any trailing whitespace (like newline characters)
        line = line.strip()
        # Split the line into pairs of two characters
        pairs = [line[i:i+2] for i in range(0, len(line), 2)]
        # Print each pair
        for pair in pairs:
            print(pair)
