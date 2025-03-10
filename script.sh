#!/bin/bash


az devops configure --defaults organization=https://dev.azure.com/markveltzer project=training


REPO_NAME="TomerRepoFromScriptsNEW"


EXISTING_REPO=$(az repos list --query "[?name=='$REPO_NAME'].name" -o tsv)
if [ -z "$EXISTING_REPO" ]; then
  echo "Creating repository $REPO_NAME"
  az repos create --name $REPO_NAME
else
  echo "Repository $REPO_NAME already exists."
fi


PAT="B8TVCqdPG2lUb5YiS3gr8mYzeWHhGObV1bRLajgDlSekRn214DWJJQQJ99BCACAAAAAAAAAAAAASAZDO4RqN"


REPO_URL="https://$PAT@dev.azure.com/markveltzer/training/_git/$REPO_NAME"


if [ ! -d ".git" ]; then
  git init
fi


git remote remove origin 2>/dev/null


git remote add origin $REPO_URL


git pull origin main --rebase


mkdir -p python_project


cat <<EOL > python_project/app.py
def greet(name):
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(greet("Azure DevOps"))
EOL


mkdir -p python_project/tests


cat <<EOL > python_project/tests/test_app.py
import unittest
import sys
import os


sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '../python_project')))

from app import greet

class TestGreet(unittest.TestCase):
    def test_greet(self):
        self.assertEqual(greet("Azure DevOps"), "Hello, Azure DevOps!")

if __name__ == "__main__":
    unittest.main()
EOL


git add azure-pipelines.yml
git commit -m "Added Azure Pipeline YAML file"
git push -u origin main


git add python_project/


git commit -m "Added Python code and tests"


git push -u origin main


az pipelines create --name "TomerPipeLine2" --repository "$REPO_NAME" --repository-type "tfsgit" --yaml-path azure-pipelines.yml --org https://dev.azure.com/markveltzer --project training


az pipelines run --name "TomerPipeLine2" --org https://dev.azure.com/markveltzer --project training
