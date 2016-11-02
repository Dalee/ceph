.PHONY: vagrant

vagrant:
	s3cmd mb s3://htdocs
	s3cmd mb s3://files
