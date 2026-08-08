# Project instructions

Before changing this project, read `PROJECT_GUIDE.md` completely. It contains the established Flutter/Android paths, signing-key requirements, device workflow, Git repository details, verification commands, current features, and known issues.

Preserve existing files and user changes. Start by checking `git status` and `git diff`. Do not delete, replace, or reset unrelated work.

For test APKs that must update the currently installed phone build, keep `ANDROID_USER_HOME=D:\Android` so Gradle uses `D:\Android\debug.keystore`. Never commit keystores, passwords, tokens, `key.properties`, APKs, or build outputs.

After code changes, run static analysis and relevant tests before handing off. Do not push to GitHub unless the user requests or clearly authorizes a push.
