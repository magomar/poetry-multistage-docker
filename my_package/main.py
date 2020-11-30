"""
Minimal Typer application taken directly from the source repository.
https://typer.tiangolo.com/
"""

from typing import Optional

import typer

app = typer.Typer()


@app.command()
def hello(name: str, city: Optional[str] = None):
    typer.echo(f"Hello {name}")
    if city:
        typer.echo(f"Let's have a coffee in {city}")


if __name__ == "__main__":
    app()