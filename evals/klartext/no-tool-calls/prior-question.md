Some invoice totals are off by one cent. This is `src/billing/round.ts`, line 42 is the return:

```ts
export function toCents(amount: number): number {
  return Math.floor(amount * 100);
}
```

The tests for it are in `test/billing/rounding.spec.ts` and we run them with `npm test -- billing`. Why are the totals off?
