# vim: set syntax=yaml ts=2 sw=2 sts=2 et :
#
#
#

{% if grains['nodename'] == 'dom0' %}

/var/lib/qubes/vm-kernels/mirage-firewall:
  file.directory:
    - mode: 755
    - makedirs: True

mirage_extracted:
  archive.extracted:
    - name: /var/lib/qubes/vm-kernels/
    - source: salt://mirage/mirage-firewall.tar.bz2
    - source_hash: 86d41dcf0367fcccb0596ea0d547100b9a79b6dea09acd10ca3d43469d85080f
    - archive_format: tar
    - options: -j

{% endif %}
