#!/bin/bash


# הגדרת הארגון והפרויקט
az devops configure --defaults organization=https://dev.azure.com/markveltzer project=training

# יצירת הריפוזיטורי החדש
az repos create --name TomerRepoFromScripts

# הגעת לריפוזיטורי המקומי (שמור לו במחשב קודם או גש אליו)
cd TomerRepoFromScripts

# יצירת ענף main
git checkout -b main

# אתחול Git אם לא עשית זאת קודם
git init

# הוספת כל הקבצים
git add .

# ביצוע Commit
git commit -m "Initial commit with main branch"

# חיבור ל-RIP-OSITORY החדש
git remote add origin https://dev.azure.com/markveltzer/training/_git/TomerRepoFromScripts

# שליחה של ענף main ל-Azure DevOps
git push -u origin main

# בדוק אם הריפוזיטורי והענף נוצרו בהצלחה
az repos list --output table
