# Codex desktop recurring stall — 2026-09-25

User reports messages cannot be sent until Stop-Process -Name "codex" -Force is run.

Local time UTC+8. Desktop reports 26.917.71314; Windows package is 26.917.9434.0.

Findings:
- At 10:35:55, the current conversation repeatedly reports Conversation state not found, while thread/read requests succeed in 3–46 ms. The backend was responding to these read requests; this does not prove message submission was healthy.
- At approximately 10:36:36 the app-server connection is restarted. This is consistent with the user's forced termination, and must not be treated as evidence of a spontaneous crash.
- At 10:36:40.750 the desktop reports app_server_restart_recovery_done and resumedCurrentConversation=true.
- Unknown-conversation turn events also occur near ephemeral description generation; they are not independently proof of the fault.
- At 10:36:47 a codex_app MCP tools/list request times out after 10 seconds, after restart; causality is unproven.

Working hypothesis: desktop conversation state / backend synchronization or recovery defect. Exact trigger and permanent fix are not established. No settings changed, no processes stopped during this investigation.

Selected local log evidence (timestamps UTC):

```text
Line 500: 2026-09-25T02:35:55.030Z info [AppServerConnection] response_routed broadcastFallback=false conversationId=[REDACTED-CONVERSATION-ID] durationMs=46 errorCode=null hadInternalHandler=false hadPending=true method=thread/read originWebcontentsId=1 queueWaitMs=0 requestId=[REDACTED-CONVERSATION-ID] targetDestroyed=false
Line 501: 2026-09-25T02:35:55.035Z error [electron-message-handler] Conversation state not found conversationId=[REDACTED-CONVERSATION-ID] rendererWebContentsId=1 rendererWindowAppearance=primary rendererWindowFocused=true rendererWindowId=1 rendererWindowVisible=true
Line 503: 2026-09-25T02:35:55.048Z info [AppServerConnection] response_routed broadcastFallback=false conversationId=[REDACTED-CONVERSATION-ID] durationMs=3 errorCode=null hadInternalHandler=false hadPending=true method=thread/read originWebcontentsId=1 queueWaitMs=0 requestId=[REDACTED-CONVERSATION-ID] targetDestroyed=false
Line 504: 2026-09-25T02:35:55.049Z error [electron-message-handler] Conversation state not found conversationId=[REDACTED-CONVERSATION-ID] rendererWebContentsId=1 rendererWindowAppearance=primary rendererWindowFocused=true rendererWindowId=1 rendererWindowVisible=true
Line 505: 2026-09-25T02:35:55.064Z info [AppServerConnection] response_routed broadcastFallback=false conversationId=[REDACTED-CONVERSATION-ID] durationMs=2 errorCode=null hadInternalHandler=false hadPending=true method=thread/read originWebcontentsId=1 queueWaitMs=0 requestId=[REDACTED-CONVERSATION-ID] targetDestroyed=false
Line 528: 2026-09-25T02:35:55.568Z info [AppServerConnection] response_routed broadcastFallback=false conversationId=[REDACTED-CONVERSATION-ID] durationMs=4 errorCode=null hadInternalHandler=false hadPending=true method=thread/read originWebcontentsId=1 queueWaitMs=0 requestId=[REDACTED-CONVERSATION-ID] targetDestroyed=false
Line 589: 2026-09-25T02:36:36.236Z info [AppServerConnection] app_server_connection.state_changed cause=post_initialize_connection_state connectionError=null currentConnectionId=2 currentState=connecting hasConnection=true hostId=local initialized=true initializeInFlight=false next=connected pendingClientRequests=0 pendingInternalRequests=0 previous=connecting reconnectAttempt=0 reconnectTimerScheduled=false restartInFlight=false targetConnectionId=2 targetReadyState=1 transport=stdio
Line 605: 2026-09-25T02:36:36.820Z info [AppServerConnection] app_server_connection.state_changed cause=transport_closed closeCode=4294967295 closedConnectionId=2 closeSignal=null connectionError={"code":"connection-failed","message":"write EPIPE"} currentConnectionId=null currentState=connected hasCloseReason=true hasConnection=false hostId=local initialized=false initializeInFlight=false next=error pendingClientRequests=24 pendingInternalRequests=3 previous=connected reconnectAttempt=0 reconnectTimerScheduled=false restartInFlight=false targetConnectionId=null targetReadyState=null transport=stdio wasInitialized=true wasLoginRequired=false wasVersionError=false
Line 608: 2026-09-25T02:36:36.822Z info [AppServerConnection] app_server_connection.state_changed cause=start_process connectionError={"code":"connection-failed","message":"write EPIPE"} currentConnectionId=null currentState=error hasConnection=false hostId=local initialized=false initializeInFlight=false next=connecting pendingClientRequests=0 pendingInternalRequests=0 previous=error reconnectAttempt=0 reconnectTimerScheduled=false restartInFlight=false targetConnectionId=null targetReadyState=null transport=stdio
Line 770: 2026-09-25T02:36:40.750Z info [electron-message-handler] app_server_restart_recovery_done currentConversationExistsOnTargetHost=true currentConversationId=[REDACTED-CONVERSATION-ID] hostId=local rendererWebContentsId=1 rendererWindowAppearance=primary rendererWindowFocused=false rendererWindowId=1 rendererWindowVisible=true resumedCurrentConversation=true
```
