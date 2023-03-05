projectname=$1

# Delete specific Jupyter kernel for this project
jupyter kernelspec uninstall $projectname

# Exit from the virtual environment :
deactivate

# Delete project directory
rm -rf /workspace/$projectname
