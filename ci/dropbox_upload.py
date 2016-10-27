# -*- coding: utf-8 -*-
"""
Script for uploading securely built distributions (artifacts) to private
Dropbox directory.
Dropbox authorization token should be provided only as environment variable
in a secure form. In case of CI systems (AppVeyor, Travis CI) this should
be provided as encrypted value in CI configuration file.
We prefer to use this method instead of native artifacts collection routine
provided by given CI system because it is more consistent.
"""

import os

import dropbox
import dropbox.files

dropbox_token = os.environ.get('DROPBOX_TOKEN')

dbx = dropbox.Dropbox(dropbox_token)


for root, dirs, files in os.walk('dist'):
    for filename in files:
        local_path = os.path.join(root, filename)
        relative_path = os.path.relpath(local_path, 'dist')
        dropbox_path = "/" + relative_path

        with open(local_path, 'rb') as f:
            print("uploading %s" % local_path)
            dbx.files_upload(
                f.read(), dropbox_path,
                dropbox.files.WriteMode('overwrite')
            )
