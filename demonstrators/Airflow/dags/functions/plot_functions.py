from esa_climate_toolbox.core import add_local_store
from esa_climate_toolbox.core import get_store
from esa_climate_toolbox.core.types import PolygonLike
from esa_climate_toolbox.ops import plot_map
from esa_climate_toolbox.ops import plot_contour


def plot_chain_output(in_folder: str, ds_name: str, region: PolygonLike, var_name: str, title: str, out_file: str) -> None:
    local_store_id = add_local_store(in_folder)
    local_store = get_store(local_store_id)
    ds = local_store.open_data(ds_name)
    plot_map(ds, var=var_name, region=region, title=title, file=out_file)
    
