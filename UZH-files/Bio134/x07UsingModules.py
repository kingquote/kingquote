import x07Statistics as stat
WT=[34.78, 72.73, 72.73, 66.67, 73.33, 68.18, 88.89, 91.67, 77.78]
MCM7=[16.67, 66.67, 20.00, 12.50, 46.15, 40.00, 40.00, 0.00, 66.67, 0.00, 40.00, 66.67, 100.00, 63.64, 75.00, 50.00, 40.00]


print('            Mean WT: {}'.format(stat.average(WT)))
print('  Standard Error WT: {}'.format(stat.standarderror(WT)))
print('          Mean MCM7: {}'.format(stat.average(MCM7)))
print('Standard Error MCM7: {}'.format(stat.standarderror(MCM7)))