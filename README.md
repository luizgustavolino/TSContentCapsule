##TSContentCapsule

Content Capsule makes it easier and safer to perform asynchronous tasks on iOS!
You can:
- Write and reuse classes to perform background tasks (called 'capsules')
- Write inline network code that does not block the UI
- Write callbacks that auto avoid calling the UI outside the main thread
- Configure thread pool size, for better memory management in each case
- Discard queued capsules, using filters

__Included sample:__ Pinterest image grid! (async loading the feed and all images)

###Roadmap

- Improve the way that users can get this tool (maybe using cocoapods?).
- Write more discard filters (by delegate, by thread affinity etc)
- Write a affinity system, where a capsule can run only in a subset of the thread pool
- Write more reusable common capsules ( download json, upload data, download progress, oauth, websocket)
- Build a probe class that's log how many threads are currently active/free.
