def combinations(elements, r):
    if r == 0:
        return [[]]
    if len(elements) == 0:
        return []

    my_combinations = []
    for i in range(len(elements)):
        current = elements[i]
        remaining = elements[i + 1:]
        for combination in combinations(remaining, r - 1):
            my_combinations.append([current] + combination)
    
    return my_combinations

def generate_permutations(m):
    grid = [[False] * 3 for _ in range(3)]
    indices = list(range(9))
    my_combinations = combinations(indices, m)
    permutations = []
    for combination in my_combinations:
        for index in combination:
            x, y = divmod(index, 3)
            grid[x][y] = True
        permutation = [row[:] for row in grid]
        permutations.append(permutation)
        for index in combination:
            x, y = divmod(index, 3)
            grid[x][y] = False
    return permutations

def generate_all_permutations():
    all_permutations = []
    for n in range(1, 10):
        permutations = generate_permutations(n)
        all_permutations.extend(permutations)
    return all_permutations

permutations = generate_all_permutations()
for permutation in permutations:
    print(permutation)

