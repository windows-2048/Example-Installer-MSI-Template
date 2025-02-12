import os
import shutil
import argparse
import yaml
from jinja2 import Template, Environment

# Constants
TEXT_FILE_WILDCARD_SET = ["*.txt", "*.c", "*.h", "*.cpp", "*.hpp", "*.rc", "*.py", "*.bat", "*.iss", "*.wxs", "*.sh"]  # Add or modify wildcards as needed

# Step 1: Parse _config.yml
def parse_config(config_file):
    config = ''
    try:
        with open(config_file, 'r', encoding='utf-8') as file:
            config = yaml.safe_load(file)
            dump = yaml.dump(config)
            print(f"config dump = {dump}")
    except Exception as e:
        print(f"Error opening or reading or parsing {config_file}: {e}")
    return config

# Step 2 & 3: Traverse and copy directory structure
def copy_and_process_directory(src, dst, config, wildcards):
    try:
        if not os.path.exists(dst):
            os.makedirs(dst)
    except Exception as e:
        print(f"Error creating directory {dst}: {e}")
        return

    print(f"src: {src}")
    for item in os.listdir(src):
        src_path = os.path.join(src, item)
        dst_path = os.path.join(dst, item)
        print(f"dst_path: {dst_path}")

        try:
            if os.path.isdir(src_path):
                copy_and_process_directory(src_path, dst_path, config, wildcards)
            else:
                if any(item.endswith(wildcard.strip('*')) for wildcard in wildcards):
                    process_text_file(src_path, dst_path, config)
                else:
                    shutil.copy2(src_path, dst_path)
        except Exception as e:
            print(f"Error processing {src_path}: {e}")

# Step 4: Process text files using Jinja2
def process_text_file(src_path, dst_path, config):
    try:
        with open(src_path, 'r', encoding='utf-8') as src_file:
            template_content = src_file.read()
    except UnicodeDecodeError:
        print(f"Skipping non-UTF-8 file: {src_path}")
        shutil.copy2(src_path, dst_path)  # Copy the file as-is without processing
        return
    except Exception as e:
        print(f"Error reading {src_path}: {e}")
        return

    try:
        # Create a Jinja2 template with `keep_trailing_newline` enabled
        env = Environment(keep_trailing_newline=True, comment_start_string="/@", comment_end_string="@/", variable_start_string="{{", variable_end_string="}}", block_start_string="<%", block_end_string="%>")
        env.globals['basename'] = os.path.basename  # Pass the function to the template
        template = env.from_string(template_content)
        # Render the template with the config values
        rendered_content = template.render(config)
    except Exception as e:
        print(f"Error rendering template for {src_path}: {e}")
        return

    try:
        with open(dst_path, 'w', encoding='utf-8') as dst_file:
            dst_file.write(rendered_content)
    except Exception as e:
        print(f"Error writing to {dst_path}: {e}")

# Main function
def main():
    # Set up command-line argument parsing
    parser = argparse.ArgumentParser(description="Copy and process a directory tree with template replacement.")
    parser.add_argument("parent_path", help="The full path to the parent directory to copy and process.")
    parser.add_argument("config_file", help="The full path to the configuration file (_config.yml).")
    args = parser.parse_args()

    try:
        config = parse_config(args.config_file)
        if not config:
            print(f"Error: No valid configuration found in {args.config_file}")
            return
        copy_and_process_directory(args.parent_path, os.getcwd(), config, TEXT_FILE_WILDCARD_SET)
    except Exception as e:
        print(f"Unexpected error in main function: {e}")

if __name__ == "__main__":
    main()
