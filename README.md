# uiuxsite


Database Structure
==================

* **user**/{uid}/
  User private data. No one else has access to here accept for the user.

* **user**/{uid}/**project**
  Projects that user is a member of (including owned projects)

* **project**/{projectId}/
  * _attributes_:
    * name - project name

* **project**/{projectId}/**page**/{pageId}
  * _attributes_:
    * name - page name
  
* **project**/{projectId}/**page**/{pageId}/**object**/{objectId}
  * _attributes_:
    * name
    * left
    * top
    * height
    * width


# codesite
# gamepub
