WITH
  account_emails AS (
    SELECT
      account_id,
      id_message,
      DATE_ADD(date, INTERVAL visit_date DAY) AS email_visit_date
    FROM `DA.account_session` ac_s
    LEFT JOIN `DA.session` s
      ON ac_s.ga_session_id = s.ga_session_id
    LEFT JOIN `DA.email_visit` ev
      ON ac_s.account_id = ev.id_account
  ),
  rfm AS (
    SELECT
      account_id,
      COUNT(DISTINCT id_message) AS visit_cnt,
      MAX(email_visit_date) AS last_visit_date,
      COUNT(DISTINCT id_message) * 10 AS revenue
    FROM account_emails
    GROUP BY account_id
    HAVING last_visit_date IS NOT NULL AND visit_cnt > 0
  )
SELECT * FROM rfm
