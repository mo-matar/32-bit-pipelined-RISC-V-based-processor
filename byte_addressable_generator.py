with open("instructions.txt", "r") as file:
    # Loop through each line in the file
    for line in file:
        # Remove any trailing whitespace 
        line = line.strip()
        # Split the line into pairs of two characters
        pairs = [line[i:i+2] for i in range(0, len(line), 2)]
        for pair in pairs:
            print(pair)
