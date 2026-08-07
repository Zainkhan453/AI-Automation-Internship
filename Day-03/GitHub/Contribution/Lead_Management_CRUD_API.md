# Lead Management CRUD API (Webhooks + Google Sheets)

A complete REST API built entirely from n8n webhook nodes, using a Google Sheet as the data store. Four endpoints live in a single workflow — no server code required.

## What it does

Exposes a working CRUD API for managing sales leads:

| Method | Endpoint | Description | Success | Failure |
|--------|----------|-------------|---------|---------|
| `POST` | `/create-lead` | Validates and appends a new lead | `201` | `400` if name or email missing |
| `GET` | `/get-leads` | Returns every lead in the sheet | `200` | — |
| `PUT` | `/update-lead` | Updates a lead matched by email | `200` | `404` if email not found |
| `DELETE` | `/delete-lead` | Deletes a lead matched by email | `200` | `404` if email not found |

## Why it might be useful to others

Most webhook examples stop at "receive data, append row". This one covers the parts that break in practice:

- **Validation before the write** — the create branch rejects incomplete payloads with a `400` instead of writing a half-empty row.
- **Zero-result lookups don't hang the request.** A Google Sheets lookup that matches nothing returns zero items, which halts the branch — the Respond node never fires and the caller just times out. Both lookup nodes here have **Always Output Data** enabled so an IF node can catch the empty case and return a proper `404`.
- **Email as the business key**, not row number. Row numbers shift when rows are sorted or deleted, so matching on email keeps update and delete stable.
- **Real status codes** — `201` on create rather than a blanket `200`, `404` rather than a silent success.

## Google Sheet setup

Create a sheet with these headers in row 1, spelled exactly:

| Name | Email | Phone | Company | Interest | Created At |
|------|-------|-------|---------|----------|------------|

## Installation

1. Import `Lead_Management_CRUD_API.json` into n8n.
2. On each of the six Google Sheets nodes: select your **Google Sheets OAuth2** credential and replace `REPLACE_WITH_SPREADSHEET_ID` with your spreadsheet ID.
3. Confirm the sheet/tab name matches your own (defaults to `Sheet1`).
4. **Activate the workflow** — the production `/webhook/` URLs only respond while it is active.

## Example

```bash
curl -X POST https://<your-instance>/webhook/create-lead \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Muhammad Ahmad",
    "email": "ahmad@example.com",
    "phone": "+923001234567",
    "company": "Example Co",
    "interest": "AI Automation"
  }'
```

```json
{ "success": true, "message": "Lead created successfully" }
```

## Notes

- `Created At` is written as an ISO timestamp; adjust the timezone in the Append node to suit your region.
- Google Sheets is not transactional. For concurrent or high-volume traffic, swap the Sheets nodes for a real database.
- The webhook nodes have authentication set to **None** for ease of testing. Enable **Header Auth** before exposing this publicly.

## Credentials required

- Google Sheets OAuth2

No other credentials, API keys or external services are needed.
