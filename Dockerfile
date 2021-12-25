# ----------
# EPJ - Full scalable, multistage, gitlab pipeline build optimized
# ----------

FROM python:3.8-alpine AS builder
RUN apk update && apk add --upgrade alpine-sdk
COPY requirements.txt /app/
WORKDIR /app
RUN pip install -U wheel
RUN pip wheel -r requirements.txt -w /wheels/

FROM python:3.8-alpine AS runner
LABEL maintainer="Jalapeno Gr.8 team, m.eberhard, d.kalberer, g.fluetsch"
COPY --from=builder /wheels /wheels
RUN pip install wheels/*
COPY src /app/src
RUN addgroup -S appgroup && adduser -S svcuser -G appgroup
RUN chown -R svcuser:appgroup /app
WORKDIR /app
USER svcuser
ENTRYPOINT ["gunicorn", "-b", "0.0.0.0:5000", "src.app:APP"]


# ----------
