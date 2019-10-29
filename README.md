# prometheus__grok_exporter--apache2
Grok_exporter yaml config files for Apache2 access and error logs. For use with Prometheus.

## Description
These are grok_exporter (https://github.com/fstab/grok_exporter) configuration YAML files for extended Apache log files. It allows you to see three main metrics:

1. A total count of errors in the Apache2 errors.log, split (labelled) by the Language of the error (Usually PHP in my case) and the title of the error. This won't output any stack trace lines from the log.
This means you will be able to see lines on your prometheus graph for each combination of language and error title (first word proceeding the language in the log file).

2. A total count of responses in the Apache2 access.log, split (labelled) by each response code. (200, 404, 500, etc..). This will allow you to track the rate of these types of responses.

3. A guage of the latency of the requests made by Apache2 in microseconds. This is split (labelled) by both the response code (200,404,500,etc...) and the file being requested. This will allow you to see which files take the longest to be served and how long they take. It will also show which files are erroring.

## Setup.

A few things need to happen to set up the grok_exporter configs correctly.

### Apache. 

A new 'LogFormat' line in the `/etc/apache2/apache2.conf` config file (on ubuntu) was created to include the request duration and filename into the log lines. THis consisted of:

```
LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\" %D %f" extended
```
The %D and %f are the variable that provide those pieces of information.

Next, the vhost file `CustomLog` eentry needs to now use that new log format, so change the line to:

```
CustomLog ${APACHE_LOG_DIR}/access.log extended 
```

This means the access.log will now use the 'extended' LogFormat just created.

### Grok_exporters

There are a couple of separate one-liner shell scripts to run the separate grok_exporter instances in the background. Note that they are running on two diffrent ports for prometheus to poll. 

- Gotcha 1: Remember to open up those ports on your firewall with IPTables!
- Gotcha 2: Grok_exporter cannot run multiple configs / log files at the same time, so multiple instances are required.

### Prometheus

For Prometheus to pick up the grok_exporters, you'll need to make sure that you include your grok_exporter instances. Edit you `Prometheus.yml` file with the two new targets.

```
- job_name: grok_errors
    target_groups:
      - targets: ['localhost:9144']

  - job_name: grok_responses
    target_groups:
      - targets: ['localhost:9145']
```

Reload the prometheus config with a curl request: `curl -X POST http://localhost:9090/-/reload`

## Links to things that helped along the way...

- https://github.com/fstab/grok_exporter
- https://prometheus.io/docs/prometheus/latest/querying/api/
- http://grokdebug.herokuapp.com/
- http://www.ducea.com/2008/02/06/apache-logs-how-long-does-it-take-to-serve-a-request/
- https://stackify.com/apache-error-log-explained/
- https://streamsets.com/documentation/datacollector/latest/help/datacollector/UserGuide/Apx-GrokPatterns/GrokPatterns_title.html
