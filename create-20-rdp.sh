#!/bin/bash
# Script: create-20-rdp.sh
# Creates 20 RDPs with Windows 11 in different USA zones

PROJECT_ID=$(gcloud config get-value project)
ZONES=(us-central1-a us-central1-b us-central1-c us-central1-f us-east1-b us-east1-c us-east1-d us-west1-a us-west1-b us-west1-c us-west2-a us-west2-b us-west2-c us-west3-a us-west3-b us-west4-a us-west4-b northamerica-northeast1-a southamerica-east1-b)

echo "Project: $PROJECT_ID"
echo "Creating 20 Windows 11 RDP instances..."

for i in ${!ZONES[@]}; do
  NAME="win11rdp-$i"
  ZONE="${ZONES[$i]}"
  echo "➡️ Creating $NAME in $ZONE..."

  gcloud compute instances create "$NAME" \
    --zone="$ZONE" \
    --machine-type="e2-standard-2" \
    --image-project="windows-cloud" \
    --image-family="windows-11" \
    --boot-disk-size="64GB" \
    --boot-disk-type="pd-balanced" \
    --tags=rdp \
    --metadata=windows-startup-script-cmd="net user adminuser 'P@ssword123' /add && net localgroup administrators adminuser /add" \
    --quiet
done

echo "✅ All 20 RDPs created. Now generating passwords..."

for i in ${!ZONES[@]}; do
  NAME="win11rdp-$i"
  ZONE="${ZONES[$i]}"
  echo "🔐 Generating password for $NAME..."
  gcloud compute reset-windows-password "$NAME" --zone="$ZONE" --user=adminuser --quiet
done

echo "🎉 Done. Use Remote Desktop with the external IPs and the above credentials."
