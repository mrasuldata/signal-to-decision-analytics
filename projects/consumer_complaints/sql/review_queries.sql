USE portfolio7;

-- Use DOUBLE aggregation to avoid MySQL decimal AVG rounding before Wilson calculations.
-- Known timely responses, not all complaint rows, define the rate denominator.
SELECT company, COUNT(*) complaints, COUNT(timely_flag) known_responses,
       AVG(timely_flag * 1e0) timely_rate, AVG(days_to_send) mean_days_to_send,
       DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) volume_rank
FROM consumer_complaints GROUP BY company HAVING COUNT(timely_flag) >= 20
ORDER BY timely_rate, known_responses DESC;

-- Wilson upper bound below 95%, with at least 20 known responses, is a scenario
-- signal. Two adjacent calendar months are required before escalation.
WITH monthly AS (
 SELECT company, product, complaint_month, COUNT(*) complaints,
        COUNT(timely_flag) n, AVG(timely_flag * 1e0) p
 FROM consumer_complaints GROUP BY company, product, complaint_month
), intervals AS (
 SELECT *, (p + 3.8416 / (2 * n) + 1.96 * SQRT(p * (1-p) / n
              + 3.8416 / (4 * n * n))) / (1 + 3.8416 / n) AS wilson_high
 FROM monthly WHERE n > 0
), signals AS (
 SELECT *, CASE WHEN n >= 20 AND wilson_high < 0.95 THEN 1 ELSE 0 END AS complaint_signal
 FROM intervals
), persistence AS (
 SELECT *, LAG(complaint_month) OVER w AS previous_month,
           LAG(complaint_signal) OVER w AS previous_signal
 FROM signals WINDOW w AS (PARTITION BY company, product ORDER BY complaint_month)
)
SELECT *, CASE WHEN complaint_signal = 1 AND previous_signal = 1
           AND complaint_month = DATE_ADD(previous_month, INTERVAL 1 MONTH)
           THEN 1 ELSE 0 END AS persistent_signal
FROM persistence ORDER BY complaint_month DESC, wilson_high;

-- State comparisons describe this five-state mortgage cohort, not market penetration.
SELECT state, COUNT(*) complaints, COUNT(timely_flag) known_responses,
       SUM(CASE WHEN timely_flag = 0 THEN 1 ELSE 0 END) untimely_responses,
       AVG(timely_flag * 1e0) timely_rate,
       COUNT(*) / SUM(COUNT(*)) OVER () AS share_of_selected_complaints
FROM consumer_complaints GROUP BY state ORDER BY complaints DESC;
