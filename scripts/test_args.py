import argparse

parser = argparse.ArgumentParser()
parser.add_argument("min")
args = parser.parse_args()

if args.a == 'true':
    print 'You nailed it!'