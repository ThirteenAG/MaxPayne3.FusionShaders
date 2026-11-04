float4 param0 : register(c196);
float4 param1 : register(c197);
float4 param2 : register(c198);
float4 param3 : register(c199);
float4 param4 : register(c200);
float4 param5 : register(c201);
sampler2D samp : register(s0);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float2 r2;
	r0.xyz = float3(1, 1, 0) * i.texcoord.xyx;
	r0.w = param5.x;
	r0 = tex2Dlod(samp, r0);
	r1.x = -r0.y + r0.x;
	r1.xy = (r1.xx >= 0) ? r0.xy : r0.yx;
	r2.x = min(r0.z, r1.y);
	r2.y = max(r1.x, r0.z);
	r1 = lerp(r0, r2.y, param5.y);
	r0.x = -r2.x + r2.y;
	r0 = r0.x * param5.w + -r1;
	r0 = param5.z * r0 + r1;
	r1.x = dot(r0, param0);
	r1.y = dot(r0, param1);
	r1.z = dot(r0, param2);
	r1.w = dot(r0, param3);
	r0 = r1 + param4;
	o = r0 * i.color;

	return o;
}
