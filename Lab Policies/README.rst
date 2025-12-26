=============================
Lab Policies Repository Notes
=============================


These files are generated via ReStructuredText.  For syntax details see http://docutils.sourceforge.net/docs/user/rst/quickref.html.  Edit the rst file and then use pandoc to make the tex and md files.  Commands are:

    pandoc -o data-resource-sharing.md data-resource-sharing.rst
    pandoc -o data-resource-sharing.tex data-resource-sharing.rst


Files are converted to html by the docutils python function rst2html::

    rst2html.py communication.rst communication.html
    
The HTML files are then uploaded to the website or blog in that format.  In some cases, they may be re-derived from source by the website software.  Additional semantic markup may also be added for web publication.

Versioning   
==========
Each document will have a subtitle indicating the version, update date and author(s).
The versioning of these document will be defined up as follows: 

* the major number (first digit after the decimal place) is increased when there are significant jumps in content
* the second number is incremented when only minor content or significant fixes have been added
* the revision number (third digit) is incremented when minor issues are fixed having no impact on the meaning (modified from Wikipedia's page on `version numbers <http://en.wikipedia.org/wiki/Version_number>`_).  
* New blog entries will be posted with changes to the major number increments, while minor changes will be incorporated within the post.

Notes
-----

* **Version 0.1.1**
* Updated on May 26, 2013 by Dave Bridges <dave.bridges@gmail.com>
* The version numbering for this document is described in the `Lab Policies README`_.  See the `GitHub Repository`_ for more granular changes.
 
.. _Lab Policies README: https://github.com/davebridges/Lab-Documents/blob/master/Lab%20Policies/README.rst
.. _GitHub Repository: https://github.com/davebridges/Lab-Documents/blob/master/Lab%20Policies/publication-policy.rst
