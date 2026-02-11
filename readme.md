Here is your full README in one clean, big paragraph style — simple, direct, and written like you explained it yourself 👇

---

This script is designed to manage Linux users and maintain a clean logging structure inside the project directory.
I specifically want the logs to be organized like this: the script file and a single `logs/` folder containing only
 `report.log`, not multiple scattered log files like `error.log`, `audit.log`, or date-based logs. To achieve this,
 I use `LOG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/logs"` which ensures that the logs directory is always
 created relative to where the script is located, not where it is executed from. `$(dirname "${BASH_SOURCE[0]}")` gets
 the script’s directory, `cd` moves into it, `pwd` converts it into an absolute path, and appending `/logs` creates a
 dedicated logs folder inside the project. Then `LOG_FILE="$LOG_DIR/report.log"` defines a single consistent log file
, and `mkdir -p "$LOG_DIR"` ensures the directory is created only if it doesn’t already exist.

In Bash, `$1` represents the first argument passed to the script, `$2` the second, and `$#` gives the total number of
 arguments provided by the user. When I write `[[ $# -lt 2 ]] && usage`, it means: “If the user provides less than 2 
arguments, then run the usage function.” The `&&` operator simply means “if the left side is true, execute the right 
side.” For example, if someone runs `./script add`, then `$#` becomes 1, which is less than 2, so the usage function
 runs and exits — which is correct behavior. The expression `"${3:-}"` means: “Use the third argument if it exists, 
otherwise use an empty value.” This is useful for optional parameters like group name.

The command `useradd -m -s /bin/bash -g "$GROUP" "$USER"` means: create a new user, generate a home directory (`-m`),
 assign `/bin/bash` as the default shell (`-s`), and attach the user to the specified primary group (`-g`). If I use
 `passwd -e`, it expires the password immediately, forcing the user to change their password at first login, which is
 good security practice. The check `[[ -z "$GROUP" ]] && usage` means: “If the group variable is empty, show usage and
 exit,” which prevents incomplete commands from running. For redirections, `1>` represents normal standard output,
 `2>` represents error output, and using `&>/dev/null` suppresses both standard output and error output. Overall,
 this script follows safe scripting practices with structured logging, argument validation, and controlled execution flow to make it reliable and production-ready.

How to Run the Script
1️⃣ Give execute permission
chmod +x organize.sh
2️⃣ Run with sudo (required for user management)
sudo ./organize.sh <action> <user> [group]

⚠️ Root privileges are required because user and group management needs administrative access.

Usage Examples
➜ Add a user
sudo ./organize.sh add john developers

Creates user john, assigns group developers, creates home directory, and sets bash shell.

➜ Delete a user
sudo ./organize.sh delete john
➜ Lock a user
sudo ./organize.sh lock john
➜ Unlock a user
sudo ./organize.sh unlock john
➜ Get user info
sudo ./organize.sh info john

All actions are logged inside:

logs/report.log
