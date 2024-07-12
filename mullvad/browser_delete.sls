# Delete existing browser
delete_browser:
  file.absent:
    - names:
      - /etc/skel/Downloads/mullvad*
      - /home/user/Downloads/mullvad*
      - /home/user/mullvad-browser
