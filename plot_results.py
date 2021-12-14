import matplotlib.pyplot as plt

x = []
y = []

with open('results.txt', 'r') as f:
    for line in f:
        point = line.strip().split(',')
        x.append(int(point[0]))
        y.append(float(point[1]))

plt.plot(x, y, 'o', color='red')
plt.savefig('../results.png')
