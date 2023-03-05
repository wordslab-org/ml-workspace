projectname=$1

# Create project directory
mkdir -p /workspace/$projectname
cd /workspace/$projectname

# Create virtual environment
python -m venv --system-site-packages --prompt $projectname .venv
source .venv/bin/activate
touch requirements.txt

# Create specific Jupyter kernel for this project
python -m ipykernel install --user --name=$projectname

# To exit from the virtual environment :
# deactivate
