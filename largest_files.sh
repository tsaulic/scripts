#!/bin/bash

find . -type f -exec ls -s {} \; | sort -n -r | head -10
