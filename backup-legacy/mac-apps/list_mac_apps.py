import os
import subprocess

# Function to get the list of applications in the Applications folder
def get_applications():
    apps_path = "/Applications"
    apps = [app for app in os.listdir(apps_path) if app.endswith(".app")]
    return apps

# Function to get the list of Homebrew packages
def get_brew_packages():
    try:
        result = subprocess.run(["brew", "list"], capture_output=True, text=True, check=True)
        packages = result.stdout.splitlines()
        return packages
    except subprocess.CalledProcessError as e:
        print(f"Error getting Homebrew packages: {e}")
        return []

# Function to write the lists to a file
def write_to_file(apps, packages):
    with open("mac_apps_and_brew_packages.txt", "w") as file:
        file.write("Installed Applications:\n")
        for app in apps:
            file.write(f"- {app}\n")
        
        file.write("\nHomebrew Packages:\n")
        for package in packages:
            file.write(f"- {package}\n")

# Main function to execute the tasks
def main():
    apps = get_applications()
    packages = get_brew_packages()
    write_to_file(apps, packages)
    print("List of installed applications and Homebrew packages has been saved to mac_apps_and_brew_packages.txt")

if __name__ == "__main__":
    main()