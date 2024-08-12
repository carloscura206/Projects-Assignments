
const svg = d3.select("svg");
const margin = {top: 50, right: 20, bottom: 50, left: 50};
const width = +svg.attr("width") - margin.left - margin.right;
const height = +svg.attr("height") - margin.top - margin.bottom;
const g = svg.append("g").attr("transform", `translate(${margin.left}, ${margin.top})`)

svg.attr("height", margin.top + margin.bottom + height + 50);

svg.append("text")
    .attr("x", (width + margin.right + margin.left) / 2)
    .attr("y", margin.top / 2)
    .attr("text-anchor", "middle")
    .style("font-size", "29px")
    .style("font-weight", "bold")
    .text("Highest Temperature Attained Scatter Plot Frequency")

svg.append("text")
    .attr("class", "x-axis-label")
    .attr("x", margin.left + width / 2 )
    .attr("y", margin.top + 40 + height )
    .style("text-anchor", "middle")
    .text("Cities")    

svg.append("text")
    .attr("class", "y-axis-label")
    .attr("transform", "rotate(-90)")
    .attr("x", (-height / 2) - margin.top)
    .attr("y", margin.left - 30)
    .style("text-anchor", "middle")
    .text("Temperature")    

function getCSVFiles(directory) {
    return [
        'Weather Data/CLT.csv',
        'Weather Data/CQT.csv',
        'Weather Data/IND.csv',
        'Weather Data/JAX.csv',
        'Weather Data/MDW.csv',
        'Weather Data/PHL.csv',
        'Weather Data/PHX.csv',

    ];
}

const csvFiles = getCSVFiles('Weather Data');

Promise.all(csvFiles.map(file => d3.csv(file))).then(function(files){
    const data = [];
    for (let ind = 0; ind < files.length; ind++) {
        const file = files[ind];
        for (let i = 0; i < file.length; i++){
            const d = file[i]
            d.date = new Date(d.date);
            d.actual_max_temp = +d.actual_max_temp;
            d.city = ind;
            data.push(d);      
        }
    }

    //After the data has been processed, frequeny is implemented 
    const dataEncapsulated = d3.nest()
        .key(d => d.city)
        .key(d => d.actual_max_temp)
        .rollup(values => {
            return {
                count: values.length,
                dates: values.map(c => c.date)
            }
        })
        .entries(data);
    

    const dataTransformed = []
    for (let i = 0; i < dataEncapsulated.length; i++) {
        const city = dataEncapsulated[i];
        for (let j = 0; j < city.values.length; j++) {
            const temp = city.values[j];
            const date = (temp.value.dates && temp.value.dates.length > 0) ? temp.value.dates[0] : null 
            dataTransformed.push({
                city: +city.key,
                actual_max_temp: +temp.key,
                frequency: temp.value.count,
                date: date
            })
        }
    }

    for (let i = 0; i < dataTransformed.length; i++) {
        const d = dataTransformed[i];
        if (isNaN(new Date(d.date).getTime() || !d.date)) {
            console.warn(`Invalid date for data point: ${d}`);
            d.date = null
        } else {
            d.date = new Date(d.date)
        }
    }
 
    //Implement scales
    const x = d3.scalePoint()
        .domain([...new Set(dataTransformed.map(d => d.city))])
        .range([0, width])
        .padding(1);

    const y = d3.scaleLinear()
        .domain([d3.min(dataTransformed, d => d.actual_max_temp), d3.max(dataTransformed, d => d.actual_max_temp) + 10])
        .nice()
        .range([height, 0]);
    
    const radius = d3.scaleSqrt()
        .domain([0, d3.max(dataTransformed, d => d.frequency)])
        .range([0, 20]);
    
    //Implement colorScheme
    const cities = ["CLT", "CQT", "IND", "JAX", "MDW", "PHL", "PHX"];
    const colorScheme = d3.scaleOrdinal(d3.schemeCategory10).domain(cities);

    //Implement axis and labels for them
    const xAxis = d3.axisBottom(x).tickFormat(d => cities[d])
    const yAxis = d3.axisLeft(y).ticks(10).tickFormat(d3.format(".1f"));

    g.append("g")
        .attr("class", "x axis")
        .attr("transform", 'translate(0,' + height + ')' )
        .call(xAxis);

    g.append("g")
        .attr("class", "y axis")
        .call(yAxis);
   
    //Implement gridLines
    function make_x_gridlines() {
        return d3.axisBottom(x).ticks(5);
    }

    function make_y_gridlines() {
        return d3.axisLeft(y).ticks(5)
    }

    g.append("g")
        .attr("class", "grid")
        .attr("transform", 'translate(0,' + height + ')' )
        .call(make_x_gridlines()
            .tickSize(-height)
            .tickFormat("")
        );

    g.append("g")
        .attr("class", "grid")
        .call(make_y_gridlines()
            .tickSize(-width)
            .tickFormat("")
        );
        
    //Create tooltip
    const tooltip = d3.select("#tooltip")
        .style("opacity", 0)
        .style("position", "absolute")
        .style("background-color", "white")
        .style("border", "1px solid #777")
        .style("padding", "5px")
        .style("pointer-events", "none")


    function jitter(value,range) {
        if (isNaN(value)){
            return value
        }
        return value + (Math.random() - 0.5) * range;
    }

    const curserClicked = function(event, d) {
        d3.event.stopPropagation();
        tooltip.style("opacity", 1)
            .html( `Temperature: ${d.actual_max_temp}`)
            .style("left", (d3.event.pageX + 5) + "px")
            .style("top", (d3.event.pageY + 5) + "px");
    }

    //Create the data points
    const circles = g.selectAll("circle")
        .data(dataTransformed)
        .enter().append("circle") 
        .attr("cx", d  => jitter(x(d.city), 60))
        .attr("cy", d => y(d.actual_max_temp))
        .attr("r", d => radius(d.frequency))
        .attr("class", d => `city-${d.city}`)
        .style("fill",  d => colorScheme(cities[d.city]))
        .style("opacity", 0.7)
        .on("click", curserClicked)


    svg.on("click", function(event){
        tooltip.style("opacity", 0)
    }) 

    const legends = d3.select("#legend")

    for (let ind = 0; ind < cities.length; ind++) {
        let specificCity = cities[ind]
        const legendObject = legends.append("div")
            .attr("class", "legend-item");

        legendObject.append("input")
            .attr("type", "checkbox")
            .attr("id", `checkbox-${ind}`)   
            .attr("checked", true)
            .on("change", function() {
                const isChecked = d3.select(this).property("checked")
                g.selectAll(`.city-${ind}`).transition().style("opacity", isChecked ? 0.7 : 0); 
                updateGridAndAxes();
            })
        legendObject.append("label")
            .attr("for", `checkbox-${ind}`) 
            .style("color", colorScheme(specificCity))
            .text(specificCity)
    }
                                   
    function updateGridAndAxes() {

        const cityShowcase = cities.filter((city, index) => d3.select(`#checkbox-${index}`).property("checked"));
        const cityIndicatorShowcase = cityShowcase.map(city => cities.indexOf(city));
        const dataShowcase = dataTransformed.filter(d => cityIndicatorShowcase.includes(d.city));
        const domainX = [...new Set(dataShowcase.map(d => d.city))];
        const domainY = [d3.min(dataShowcase, d => d.actual_max_temp), d3.max(dataShowcase, d => d.actual_max_temp) + 10];

        x.domain(domainX);
        y.domain(domainY).nice();

        g.select(".x.axis").transition().call(d3.axisBottom(x).tickFormat(d => cities[d]));
        g.select(".y.axis").transition().call(d3.axisLeft(y));

        //update and show circles based on user choice

        const updateCircles = g.selectAll("circle")
            .data(dataTransformed, d => `${d.city}-${d.actual_max_temp}`)
            
        updateCircles.enter().append('circle')
            .attr("cx", d => jitter(x(d.city), 60))
            .attr("cy", d => y(d.actual_max_temp))
            .attr("r", d => radius(d.frequency))
            .attr("class", d => `city-${d.city}`)
            .style("fill",  d => colorScheme(cities[d.city]))
            .style("opacity", d => cityIndicatorShowcase.includes(d.city) ? 0.7: 0)
            .on("click", curserClicked)
            .merge(updateCircles)
            .transition()
            .attr("cx", d  => jitter(x(d.city), 60))
            .attr("cy", d => y(d.actual_max_temp))
            .attr("r", d => radius(d.frequency))
            .style("opacity", d => cityIndicatorShowcase.includes(d.city) ? 0.7: 0)
            
        updateCircles.exit().transition().style("opacity", 0).remove();

        g.select(".x-grid").transition().call(make_x_gridlines().tickSize(-height).tickFormat(""))
        g.select(".y-grid").transition().call(make_y_gridlines().tickSize(-width).tickFormat(""))
    }

    updateGridAndAxes();
}).catch(function(error){
    console.error(error);
})

          