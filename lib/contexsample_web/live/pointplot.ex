defmodule ContexSampleWeb.PointPlotLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  import ContexSampleWeb.Shared

  alias Contex.{PointPlot, Dataset, Plot}

  def render(assigns) do
    ~L"""
      <h3>Simple Point Plot Example</h3>
      <div class="container">
        <div class="row">
          <div class="column column-25">
            <form phx-change="chart_options_changed">
              <label for="title">Plot Title</label>
              <input type="text" name="title" id="title" placeholder="Enter title" value=<%= @chart_options.title %>>

              <label for="series">Number of series</label>
              <input type="number" name="series" id="series" placeholder="Enter #series" value=<%= @chart_options.series %>>

              <label for="points">Number of points</label>
              <input type="number" name="points" id="points" placeholder="Enter #series" value=<%= @chart_options.points %>>

              <label for="colour_scheme">Colour Scheme</label>
              <%= raw_select("colour_scheme", "colour_scheme", colour_options(), @chart_options.colour_scheme) %>

              <label for="show_legend">Show Legend</label>
              <%= raw_select("show_legend", "show_legend", yes_no_options(), @chart_options.show_legend) %>

              <label for="show_legend">Custom Y Ticks</label>
              <%= raw_select("custom_y_ticks", "custom_y_ticks", yes_no_options(), @chart_options.custom_y_ticks) %>

              <label for="time_series">Time Series</label>
              <%= raw_select("time_series", "time_series", yes_no_options(), @chart_options.time_series) %>
            </form>
          </div>

          <div class="column">
            <%= build_pointplot(@test_data, @chart_options) %>
            <%= list_to_comma_string(@chart_options[:friendly_message]) %>
          </div>
        </div>
      </div>
    """

  end

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(chart_options: %{
          series: 2,
          points: 100,
          title: "Bandwidth",
          colour_scheme: "default",
          show_legend: "yes",
          custom_y_ticks: "no",
          time_series: "yes"
          })
      |> assign(counter: 0)
      |> make_test_data()

#
# socket = case connected?(socket) do
#   true ->
#     Process.send_after(self(), :tick, 100)
#     assign(socket, show_chart: true)
#   false ->
#     assign(socket, show_chart: true)
# end


    {:ok, socket}
  end

  def handle_event("chart_options_changed", %{}=params, socket) do
    socket =
      socket
      |> update_chart_options_from_params(params)
      |> make_test_data()

    {:noreply, socket}
  end

  def handle_info(:tick, socket) do
    counter = socket.assigns.counter
    Process.send_after(self(), :tick, 100)
    {:noreply, assign(socket, counter: counter + 1) |> make_test_data()}
  end

  def build_pointplot(dataset, chart_options) do
    y_tick_formatter = case chart_options.custom_y_ticks do
      "yes" -> &custom_axis_formatter/1
      _ -> nil
    end

    plot_content = PointPlot.new(dataset)
      |> PointPlot.set_y_col_names(chart_options.series_columns)
      |> PointPlot.colours(lookup_colours(chart_options.colour_scheme))
      |> PointPlot.custom_y_formatter(y_tick_formatter)
      |> PointPlot.axis_label_rotation(45)

    options = case chart_options.show_legend do
      "yes" -> %{legend_setting: :legend_right}
      _ -> %{}
    end


    plot = Plot.new(800, 400, plot_content)
      |> Plot.titles(chart_options.title, nil)
      |> Plot.plot_options(options)

    Plot.to_svg(plot)
  end

  defp make_test_data(socket) do
    options = socket.assigns.chart_options
    # time_series = (options.time_series == "yes")
    # series = options.series
    # points = options.points

    # data = for i <- 1..points do
    #   x = random_within_range(0.0, 30 + (i * 3.0))
    #   series_data = for s <- 1..series do
    #     (s * 8.0) + random_within_range(x * (0.1 * s), x * (0.15 * s))
    #   end
    #   [calc_x(x, i, time_series) | series_data]
    # end

    data = [
      [1592802000, 26721768.316, 457272061.57],
      [1592805000, 24394337.53, 394493603.36],
      [1592808000, 15641118.311, 276221977.9],
      [1592811000, 14336215.546, 219208497.79],
      [1592814000, 12070256.664, 208173161.75],
      [1592817000, 13840959.731, 186982600.87],
      [1592820000, 13152685.885, 158153786.44],
      [1592823000, 16502606.246, 148952050.12],
      [1592826000, 14464338.222, 179301234.58],
      [1592829000, 16545703.391, 243077564.96],
      [1592832000, 19754771.364, 289611821.28],
      [1592835000, 28704216.21, 333478946.11],
      [1592838000, 32864476.153, 324268727.32],
      [1592841000, 31921233.503, 305491923.71],
      [1592844000, 27506291.365, 286681852.86],
      [1592847000, 24544210.402, 338330409.54],
      [1592850000, 26344788.358, 417834070.5],
      [1592853000, 29181990.104, 396739691.29],
      [1592856000, 30544468.772, 423264126.73],
      [1592859000, 29010361.09, 572487490.86],
      [1592862000, 30683746.683, 631314252.79],
      [1592865000, 27381104.372, 484371050.62],
      [1592868000, 32025532.834, 507398612.24],
      [1592871000, 30306396.656, 629404969.96],
      [1592874000, 36254156.228, 654276151.9],
      [1592877000, 42721992.441, 692783144.02],
      [1592880000, 41240710.504, 725521760.46],
      [1592883000, 34705965.758, 645645294.22],
      [1592886000, 27907035.388, 535377372.52],
      [1592889000, 26568622.965, 453952425.38],
      [1592892000, 24975735.963, 448907983.25],
      [1592895000, 19574635.92, 419234808.58],
      [1592898000, 15499129.331, 291065934.63],
      [1592901000, 13548780.557, 224727670.61],
      [1592904000, 15529013.417, 174716931.35],
      [1592907000, 14671241.684, 164501610.15],
      [1592910000, 26986183.083, 183038892.23],
      [1592913000, 19727839.151, 249965560.36],
      [1592916000, 23285586.41, 266500207.65],
      [1592919000, 21357261.265, 335275328.44],
      [1592922000, 27883142.555, 389020275.49],
      [1592925000, 33359874.111, 402892670.65]
    ]
    |> Enum.map(fn [t, i, o] ->
      {:ok, dt} = DateTime.from_unix(t)
      [dt, i, o]
    end)

    series_cols = [
      "Outbound",
      "Inbound"
    ]

    test_data = Dataset.new(data, ["X" | series_cols])

    options = Map.put(options, :series_columns, series_cols)

    assign(socket, test_data: test_data, chart_options: options)
  end

  # @date_min ~N{2019-10-01 10:00:00}
  # @interval_us 600 * 1_000_000
  # defp calc_x(x, _, false), do: x
  # defp calc_x(_, i, _) do
  #   Timex.add(@date_min, Timex.Duration.from_microseconds(i * @interval_us))
  # end
  #
  #
  # defp random_within_range(min, max) do
  #   diff = max - min
  #   (:rand.uniform() * diff) + min
  # end

  def custom_axis_formatter(value) do
    "Mb/sec #{:erlang.float_to_binary(value/1_000_000.0, [decimals: 1])}"
  end


end
