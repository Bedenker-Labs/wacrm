-- ============================================================
-- 047_ai_handoff_automation.sql — AI handoff falls back to an automation
--
-- Until now, when the AI assistant hits its handoff branch (it can't
-- answer, or explicitly defers), the only thing that happened was
-- ai_configs.handoff_agent_id routing the conversation to a human (or
-- the shared queue if unset) -- the customer got silence until someone
-- picked it up.
--
-- handoff_automation_id lets an account configure a specific
-- `automations` row (e.g. a pre-existing keyword-triggered menu flow)
-- to run immediately as a fallback, in ADDITION to the human handoff
-- (not instead of it) -- see dispatchInboundToAiReply in
-- src/lib/ai/auto-reply.ts. The referenced automation's own
-- is_active/trigger_type are irrelevant here: it's invoked directly by
-- id, bypassing normal trigger matching (see
-- runAutomationForContact in src/lib/automations/engine.ts).
--
-- Idempotent — safe to run multiple times.
-- ============================================================

ALTER TABLE ai_configs
  ADD COLUMN IF NOT EXISTS handoff_automation_id uuid REFERENCES automations(id) ON DELETE SET NULL;
