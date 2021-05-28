# Tcl IdentityServer and REST
A Tcl implementation of an IdentityServer OAuth 2.0 client and a REST Service Wrapper

This was created for a Hackathon at my work. It only has very limited implementation, but it should be a good guide on how to implement your own services.

If I revisit this project, the roadmap is something like this...
1. Add capability to use the refresh token.
2. Add ability to parse discovery document to get endpoints.
3. Add more overloads / support to wrapper methods for REST operations.
4. Proper error handling.
5. Expand to other OAuth implementations and see how it works.

If you are using this and starting from scratch, here is what you need to do:
1. Use bin/ActiveTcl.exe to install tclsh to your machine.
2. On the command line navigate to the lib/tcllib directory and run "tclsh installer.tcl" to install the tcllib libraries necessary.


Items in "bin" and "lib" directory are not my code, but are included for the purposes of illustrating the prerequisites.
