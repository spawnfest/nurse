defmodule Nurse.Condition.Response do
  @spec check(Nurse.response(), Nurse.response_condition()) :: boolean()
  def check(response, {:not, response_condition}), do: !check(response, response_condition)

  def check(response, {:and, response_condition_1, response_condition_2}),
    do: check(response, response_condition_1) and check(response, response_condition_2)

  def check(response, {:or, response_condition_1, response_condition_2}),
    do: check(response, response_condition_1) or check(response, response_condition_2)

  def check({status_code, _headers, _body}, {:status_code_match, status_code_match}),
    do: status_code_match(status_code, status_code_match)

  def check({_status_code, headers, _body}, {:headers_match, headers_match}),
    do: headers_match(headers, headers_match)

  def check({_status_code, _headers, body}, {:body_match, body_match}),
    do: body_match(body, body_match)

  def check(_response, _response_condition), do: false

  @spec status_code_match(Nurse.status_code(), Nurse.code_match()) :: boolean()
  defp status_code_match(status_code, {:code_equal, status_code}), do: true

  defp status_code_match(status_code, {:code_range, first, last}) when status_code in first..last,
    do: true

  defp status_code_match(status_code, {:code_class, class}) do
    status_code
    |> Integer.digits()
    |> List.first()
    |> (&(&1 == class)).()
  end

  defp status_code_match(status_code, {:code_regex, regex}),
    do: status_code |> Integer.to_string() |> String.match?(regex)

  defp status_code_match(_status_code, _status_code_match), do: false

  @spec headers_match(Nurse.headers(), Nurse.keyword_list_match()) :: boolean()
  defp headers_match(headers, {:keyword_list_has_key, key}),
    do: headers |> Keyword.has_key?(String.to_atom(key))

  defp headers_match(headers, {:keyword_list_contains, {key, value}}),
    do: value == Keyword.get(headers, String.to_atom(key))

  defp headers_match(_headers, _headers_match), do: false

  @spec body_match(Nurse.body(), Nurse.string_match()) :: boolean()
  defp body_match(body, {:string_exact, body}), do: true
  defp body_match(body, {:string_iexact, string}), do: body |> String.match?(~r/^#{string}$/i)
  defp body_match(body, {:string_contains, string}), do: body |> String.contains?(string)
  defp body_match(body, {:string_icontains, string}), do: body |> String.match?(~r/#{string}/i)
  defp body_match(body, {:string_starts_with, string}), do: body |> String.starts_with?(string)

  defp body_match(body, {:string_istarts_with, string}),
    do: body |> String.match?(~r/^#{string}/i)

  defp body_match(body, {:string_ends_with, string}), do: body |> String.ends_with?(string)
  defp body_match(body, {:string_iends_with, string}), do: body |> String.match?(~r/#{string}$/i)
  defp body_match(body, {:string_regex, regex}), do: body |> String.match?(regex)
  defp body_match(_body, _body_match), do: false
end
