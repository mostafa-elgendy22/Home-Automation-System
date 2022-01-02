area = float(input("Movable Area: "))
clock = float(input("clock: "))
slack = float(input("Slack: "))
pw = float(input("Power: "))

result = float(0.5 * area + 0.3 * (clock*1000 - slack) + 0.2 * pw)
print("result:", result)