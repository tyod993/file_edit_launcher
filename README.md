# file_edit_launcher

An API used to open/edit a file in another app.

## Overview

This plugin provides and API for editing a file using a third-party app. 

This plugin uses code from the [open_file](https://pub.dev/packages/open_file) plugin. On the Android 
side the code has been hollowed out and changed to Kotlin. The IOS code was simply copied and not changerd.
We also added the key functionality of editing a file. Editing Files is currently only supported on Android.
For Android we're using Intents and FileProvider to open and edit files in other apps.

## Getting Started

The Flutter side of this API is very symple. It consists of one function 
used to open and edit the desired file. Keep in mind when editing a file
that it must be in a directory allowing edits. 

## Example 

In this example we create a pdf and save it in a file. Afterwhich we open it to let the user update it. 

```dart
    var dir = await getExternalStorageDirectory();
    var dirPath = dir?.absolute.path;
    var file = File("$dirPath/temp.pdf");
    var pdf = createPdf();
    await file.writeAsBytes(await pdf.save());
    
    final result = await FileEditLauncher.launchFileEditor(file);
    
```

When the user has finished viewing or editing a file you'll recieve a [LauncherResult](https://github.com/enfold/flutter_sandbox/blob/master/file_edit_launcher/lib/launcher_response.dart). Make sure to handle the errors returned here properly.

## Notes

There are a few potential problems that may arise when using this plugin. 

When there is conflict with other plugins about FileProvider, add code below in your /android/app/src/main/AndroidManifest.xml

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
          xmlns:tools="http://schemas.android.com/tools"
          package="xxx.xxx.xxxxx">
    <application>
        ...
        <provider
                android:name="androidx.core.content.FileProvider"
                android:authorities="${applicationId}.fileProvider"
                android:exported="false"
                android:grantUriPermissions="true"
                tools:replace="android:authorities">
            <meta-data
                    android:name="android.support.FILE_PROVIDER_PATHS"
                    android:resource="@xml/filepaths"
                    tools:replace="android:resource" />
        </provider>
    </application>
</manifest>
```


## TODO 

### IOS 

Firstly if doing all this in swift is possible that would be great.

Currently the IOS version of this package only opens a file for viewing
but lacks the ability to edit the file in place. The package being used atm
is UIDocumentInteractionController. This package allows us to open the file 
but lacks the editing funcitonality(as far as I can tell). IOS has a function
called openDocument that should do this for you. In not sure what this would
be on the swift side. 

The package must use the MethodChannel to communicate with the Flutter/dart 
layer. The channel you should be listening on is `'file_edit_launcher'`. This
channel on the dart side and android side only consist of one call being
`'launch_file_editor'`. This MUST be carried over to the IOS package or it 
obviously wont work. The call has only one argument being `'file_path'` which
is a String. Using the file_path we want to open the file in a 3rd-party app
to edit the file and recieve a callback when they are finished and return 
the string `'Done Editing'` when finished. Make sure this is passed as a success
to the method channel. 

On the Dart side we return a LauncherResult object that holds either 
`successful = true` or an error and stackTrace. There are only three errors
im catching currently being `'Permission Denied,` , `"File Missing"` , and
`'File Path Null'`. These strings should be passed back via the error on
your method channel. We parse them on the dart side. If there are more errors 
that i've missed just add them to the dart side. 

here is an article using objective-c describing how to do this: https://code.tutsplus.com/tutorials/ios-sdk-previewing-and-opening-documents--mobile-15130

here is the documentation on openDocument: https://developer.apple.com/documentation/appkit/nsdocumentcontroller/1515005-opendocument 