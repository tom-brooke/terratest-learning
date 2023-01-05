# terratest-learning

Learning repository for Terratest

## Create test area
```bash
# create test directory
mkdir tests && cd tests

# initialise go project
go mod init <project_name>

# handle packaging and dependencies
go mod tidy

# run tests
go tests -v -timeout 30m
```
