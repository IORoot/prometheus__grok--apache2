
<div id="top"></div>

<div align="center">

<img src="https://svg-rewriter.sachinraja.workers.dev/?url=https%3A%2F%2Fcdn.jsdelivr.net%2Fnpm%2F%40mdi%2Fsvg%406.7.96%2Fsvg%2Fregex.svg&fill=%239A3412&width=200px&height=200px" style="width:200px;"/>

<h3 align="center">Grok_exporter for Apache2</h3>

<p align="center">
    Grok_exporter yaml config files for Apache2 access and error logs. For use with Prometheus.
</p>
</div>


##  1. <a name='TableofContents'></a>Table of Contents



* 1. [Table of Contents](#TableofContents)
* 2. [About The Project](#AboutTheProject)
	* 2.1. [Built With](#BuiltWith)
* 3. [Getting Started](#GettingStarted)
	* 3.1. [Installation](#Installation)
		* 3.1.1. [Apache.](#Apache.)
		* 3.1.2. [Grok_exporters](#Grok_exporters)
		* 3.1.3. [Prometheus](#Prometheus)
* 4. [Usage](#Usage)
* 5. [Contributing](#Contributing)
* 6. [License](#License)
* 7. [Contact](#Contact)
* 8. [Changelog](#Changelog)



##  2. <a name='AboutTheProject'></a>About The Project

These are grok_exporter (https://github.com/fstab/grok_exporter) configuration YAML files for extended Apache log files. It allows you to see three main metrics:

1. A total count of errors in the Apache2 errors.log, split (labelled) by the Language of the error (Usually PHP in my case) and the title of the error. This won't output any stack trace lines from the log.
This means you will be able to see lines on your prometheus graph for each combination of language and error title (first word proceeding the language in the log file).

2. A total count of responses in the Apache2 access.log, split (labelled) by each response code. (200, 404, 500, etc..). This will allow you to track the rate of these types of responses.

3. A guage of the latency of the requests made by Apache2 in microseconds. This is split (labelled) by both the response code (200,404,500,etc...) and the file being requested. This will allow you to see which files take the longest to be served and how long they take. It will also show which files are erroring.


<p align="right">(<a href="#top">back to top</a>)</p>



###  2.1. <a name='BuiltWith'></a>Built With

This project was built with the following frameworks, technologies and software.

* [PHP](https://php.net/)
* [Composer](https://getcomposer.org/)

<p align="right">(<a href="#top">back to top</a>)</p>





##  3. <a name='GettingStarted'></a>Getting Started


###  3.1. <a name='Installation'></a>Installation


A few things need to happen to set up the grok_exporter configs correctly.

####  3.1.1. <a name='Apache.'></a>Apache. 

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

####  3.1.2. <a name='Grok_exporters'></a>Grok_exporters

There are a couple of separate one-liner shell scripts to run the separate grok_exporter instances in the background. Note that they are running on two diffrent ports for prometheus to poll. 

- Gotcha 1: Remember to open up those ports on your firewall with IPTables!
- Gotcha 2: Grok_exporter cannot run multiple configs / log files at the same time, so multiple instances are required.

####  3.1.3. <a name='Prometheus'></a>Prometheus

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


<p align="right">(<a href="#top">back to top</a>)</p>



##  4. <a name='Usage'></a>Usage

Here are some links to things that helped along the way...

- [https://github.com/fstab/grok_exporter](https://github.com/fstab/grok_exporter)
- [https://prometheus.io/docs/prometheus/latest/querying/api/](https://prometheus.io/docs/prometheus/latest/querying/api/)
- [http://grokdebug.herokuapp.com/](http://grokdebug.herokuapp.com/)
- [http://www.ducea.com/2008/02/06/apache-logs-how-long-does-it-take-to-serve-a-request/](http://www.ducea.com/2008/02/06/apache-logs-how-long-does-it-take-to-serve-a-request/)
- [https://stackify.com/apache-error-log-explained/](https://stackify.com/apache-error-log-explained/)
- [https://streamsets.com/documentation/datacollector/latest/help/datacollector/UserGuide/Apx-GrokPatterns/GrokPatterns_title.html](https://streamsets.com/documentation/datacollector/latest/help/datacollector/UserGuide/Apx-GrokPatterns/GrokPatterns_title.html)


<p align="right">(<a href="#top">back to top</a>)</p>



##  5. <a name='Contributing'></a>Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue.
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>



##  6. <a name='License'></a>License

Distributed under the MIT License.

MIT License

Copyright (c) 2022 Andy Pearson

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

<p align="right">(<a href="#top">back to top</a>)</p>



##  7. <a name='Contact'></a>Contact

Project Link: [https://github.com/IORoot/...](https://github.com/IORoot/...)

<p align="right">(<a href="#top">back to top</a>)</p>



##  8. <a name='Changelog'></a>Changelog

v1.0.0 - First version.
