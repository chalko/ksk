#!/bin/bash

name="$1"

gpg --comment "gpg --dearmor <${name}.asc >${name}" --enarmor  < "${name}" > "${name}".asc