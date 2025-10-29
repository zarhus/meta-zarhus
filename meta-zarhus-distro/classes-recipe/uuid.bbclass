def get_commit_sha(d):
    import subprocess, os

    layerdir = d.getVar('THISDIR')
    sha = subprocess.check_output(
        ['git', '-C', layerdir, 'rev-parse', 'HEAD'],
        text=True
    ).strip()

    return sha

def generate_uuid_from_sha(d, prefix):
    import hashlib, uuid

    sha = get_commit_sha(d)
    return str(uuid.UUID(hashlib.md5((prefix + sha).encode()).hexdigest()))
