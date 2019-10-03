# Windows Toolkit
This module contains various tools to assist in managing Windows Server and Desktop systems, including Microsoft server technologies such as Active Directory

Current Version:  1.0.1

[PowerShell Gallery Link](https://www.powershellgallery.com/packages/WindowsToolkit/)

---

## PreRequisites
Please install the [Remote Server Administration Tools for Active Directory](https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-non-language-fod#remote-server-administration-tools-rsat) prior to installing this module.

[Windows Management Framework 5.1](https://www.microsoft.com/en-us/download/details.aspx?id=54616) is required on systems running Windows 8.1 or earlier.

---

## Installation
Install from the PowerShell Gallery using the following command:
```PowerShell
Install-Module -Name WindowsToolkit
```

## Update
Update from the PowerShell Gallery using the following command:
```PowerShell
Update-Module -Name WindowsToolkit
```

---

## Acknowledgements

Thanks to [Boe Prox](https://github.com/proxb) for his function [Convert-OutputForCSV](https://gallery.technet.microsoft.com/scriptcenter/Convert-OutoutForCSV-6e552fc6) which is used in this module.  