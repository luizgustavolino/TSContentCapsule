###TSContentCapsule

Content Capsule makes it easier to perform asynchronous tasks on iOS! You can:
- Write and reuse classes to perform background tasks (called capsules)
- Write inline network code that does not block the UI
- Write callbacks to the same thread that created the capsule (avoiding calling the UI outside the main thread)
- Configure thread pool size (better memory management in each case)

###ROADMAP

- Improve the way that users can get this tool (maybe using cocoapods?).
- Write routines to discard capsules (like when a user tap back and leave a screen where there is queued capsules involved).
- Write a affinity system, where a capsule can run only in a subset of the thread pool
- Write more reusable common capsules ( download json, upload data, download progress, oauth, websocket)
- Build a probe class that's log how many threads are currently active/free.
