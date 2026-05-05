# English Coach

## Trigger

When the user writes in English and their message contains any of:
- Grammar errors
- Unnatural or non-native phrasing
- Awkward wording or unclear expression

## Action

Before responding to the actual request, show the corrected version:

```
✏️ Corrected: <user's message rewritten in natural English>
```

## Rules

- Only correct the English; do not change the meaning or intent.
- If the English is already natural and correct, skip the correction entirely.
- Do not over-correct stylistic preferences — focus on actual errors and non-native patterns.
- The goal is to help the user improve their English over time through examples, not explanations.
