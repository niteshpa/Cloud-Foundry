## Find Apps Using a Specific Buildpack (Cloud Foundry)
#!/bin/bash

# Desired buildpack name
BUILDPACK_NAME="staticfile"

# Output file
OUTPUT_FILE="apps_with_buildpack.txt"

# Header
echo "ORG SPACE APP BUILDPACK" > "$OUTPUT_FILE"

# Get list of orgs
ORGS=$(cf orgs | tail -n +4 | awk '{print $1}')

for ORG in $ORGS; do
  cf target -o "$ORG" >/dev/null 2>&1

  # Get spaces in the org
  SPACES=$(cf spaces | tail -n +4 | awk '{print $1}')

  for SPACE in $SPACES; do
    cf target -s "$SPACE" >/dev/null 2>&1

    # Get apps in the space
    APPS=$(cf apps | tail -n +5 | awk '{print $1}')

    for APP in $APPS; do
      # Fetch buildpack info
      BUILDPACK_INFO=$(cf app "$APP" | grep -E "^buildpacks:" | awk '{print $2}')

      if [[ "$BUILDPACK_INFO" == *"$BUILDPACK_NAME"* ]]; then
        echo "$ORG $SPACE $APP $BUILDPACK_INFO" >> "$OUTPUT_FILE"
      fi
    done
  done
done

echo "Report generated: $OUTPUT_FILE"
