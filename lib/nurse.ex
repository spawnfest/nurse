defmodule Nurse do
  @moduledoc """
  Nurse
  """

  @type scheme :: :http
  @type hostname :: binary()
  @type eport :: :inet.port_number()
  @type endpoint :: {scheme(), hostname(), eport()}

  @type check_interval :: number()
  @type check_timeout :: number()
  @type retry_delay :: number()
  @type evaluation_interval :: pos_integer()

  @type health_status :: :unknown | :starting | :healthy | :retrying | :unhealthy | :stopped

  @type method :: HTTPoison.Request.method()
  @type headers :: HTTPoison.Request.headers()
  @type body :: HTTPoison.Request.body()
  @type status_code :: 100..599
  @type request :: {method(), headers(), body}
  @type response :: {status_code(), headers(), body()}

  @type unary_logical_operator :: :not
  @type binary_logical_operator :: :and | :or

  @type response_condition :: response_aggregation() | response_leaf()
  @type response_aggregation ::
          {unary_logical_operator(), health_condition()}
          | {binary_logical_operator(), response_condition(), response_condition()}
  @type response_leaf :: status_code_matches() | header_matches() | body_matches()

  @type header_matches :: binary_matches()
  @type body_matches :: binary_matches()
  @type status_code_matches ::
          {:status_code_range, status_code(), status_code()}
          | {:status_code_class, 1..5}
          | {:status_code_regex, Regex.t()}
  @type binary_matches ::
          {:binary_exact, binary()}
          | {:binary_iexact, binary()}
          | {:binary_contains, binary()}
          | {:binary_icontains, binary()}
          | {:binary_starts_with, binary()}
          | {:binary_istarts_with, binary()}
          | {:binary_ends_with, binary()}
          | {:binary_iends_with, binary()}
          | {:binary_regex, Regex.t()}

  @type health_condition :: health_aggregation() | health_leaf()
  @type health_aggregation ::
          {unary_logical_operator(), health_condition()}
          | {binary_logical_operator(), health_condition(), health_condition()}
  @type health_leaf :: successful_probes_matches() | failed_probes_matches()
  @type successful_probes_matches :: pos_integer_matches()
  @type failed_probes_matches :: pos_integer_matches()
  @type pos_integer_matches ::
          {:pos_integer_equal, pos_integer()}
          | {:pos_integer_gt, pos_integer()}
          | {:pos_integer_gte, pos_integer()}
          | {:pos_integer_lt, pos_integer()}
          | {:pos_integer_lte, pos_integer()}
          | {:pos_integer_range, pos_integer()}

  @type retry_condition :: health_condition()
end
