REM ################################################################################################
REM # FILENAME: Config2008CA.cmd
REM # VERSION:  1.0
REM # DATE:     06.01.2017
REM # AUTHOR:   Andrew Ferguson
REM #
REM # Configures CA Server for use in environment
REM # Configures Audit policy
REM # Configures Certificate issuance and CRL publishing
REM # Causes outage of CA services
REM ################################################################################################

REM Set Variables and paths
SET myADnamingcontext= "DC=DelMunky,DC=com"
SET myhttpPKIvroot= "http://pki.delmunky.com"
SET myInsidehttpPKIvroot= "http://pki.bussiness.delmunky.com"

REM Setting Audit of CA Services
Certutil -setreg CA\AuditFilter 127
REM Setting Max CA Validity
Certutil -setreg CA\ValidityPeriodUnits 1
Certutil -setreg CA\ValidityPeriod "Years"
REM Remove Delta CRLs
Certutil -setreg CA\CRLDeltaPeriodUnits 0
Certutil -setreg CA\CRLDeltaPeriod "Days"
REM Setting CDP locations
certutil.exe -setreg CA\CRLPublicationURLs "1:%WINDIR%\system32\CertSrv\CertEnroll\%%3%%8%%9.crl\n0:http://%%1/CertEnroll/%%3%%8%%9.crl\n0:file://%%1/CertEnroll/%%3%%8%%9.crl\n6:%myInsidehttpPKIvroot%/%%3%%8%%9.crln6:%myhttpPKIvroot%/%%3%%8%%9.crl"

REM Setting  AIA locations
certutil.exe -setreg CA\CACertPublicationURLs "1:%WINDIR%\system32\CertSrv\CertEnroll\%%1_%%3%%4.crt\n0:http://%%1/CertEnroll/%%1_%%3%%4.crt\n0:file://%%1/CertEnroll/%%1_%%3%%4.crt\n6:%myInsidehttpPKIvroot%/%%1_%%3%%4.der"

REM Removing extension
Certutil -setreg Policy\DisableExtensionList +1.3.6.1.4.1.311.21.10

net stop CertSvc & net start CertSvc
certutil -CRL
Certutil -dsPublish
